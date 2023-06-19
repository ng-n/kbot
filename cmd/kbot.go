/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/spf13/cobra"

	"github.com/hirosassa/zerodriver"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/otlp/otlpmetric/otlpmetricgrpc"
	sdkmetric "go.opentelemetry.io/otel/sdk/metric"
	"go.opentelemetry.io/otel/sdk/resource"
	semconv "go.opentelemetry.io/otel/semconv/v1.12.0"
	telebot "gopkg.in/telebot.v3"
)

var (
	//TeleToken bot
	TeleToken = os.Getenv("TELE_TOKEN")

	//MetricsHost exporter host:port
	MetricsHost = os.Getenv("METRICS_HOST")
)

// Get appVersion ex. v1.0.1 from CLI
var appVersion = "Version"

// kbotCmd represents the kbot command
var kbotCmd = &cobra.Command{
	Use:     "kbot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {

		logger := zerodriver.NewProductionLogger()

		fmt.Println("kbot %s started", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		// Bot Handler
		if err != nil {
			logger.Fatal().Str("Error", err.Error()).Msg("Please check TELE_TOKEN")
			//log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		} else {
			logger.Info().Str("Version", appVersion).Msg("kbot started")
		}

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {
			//log.Print(m.Message().Payload, m.Text())
			logger.Info().Str("Payload", m.Text()).Msg(m.Message().Payload)

			payload := m.Message().Payload
			pmetrics(cmd.Context(), payload)

			switch payload {
			case "hello":
				err = m.Send(fmt.Sprintf("Hello I'm kbot %s!", appVersion))
			}

			return err
		})

		// Check Bitcoin Price
		kbot.Handle("/getbitcoinprice", func(m telebot.Context) error {
			price, err := getBitcoinPrice()
			if err != nil {
				return err
			}
			err = m.Send(fmt.Sprintf("The current price of Bitcoin is $%.2f USD", price))
			return err
		})

		kbot.Start()

	},
}

func getBitcoinPrice() (float64, error) {
	url := "https://api.coincap.io/v2/assets/bitcoin"
	resp, err := http.Get(url)
	if err != nil {
		return 0, err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return 0, err
	}

	var data map[string]interface{}
	err = json.Unmarshal(body, &data)
	if err != nil {
		return 0, err
	}

	priceStr := data["data"].(map[string]interface{})["priceUsd"].(string)
	price, err := strconv.ParseFloat(priceStr, 64)
	if err != nil {
		return 0, err
	}

	return price, nil
}

func pmetrics(ctx context.Context, payload string) {
	// Get the global MeterProvider and create a new Meter with the name "kbot_bitcoin"
	meter := otel.GetMeterProvider().Meter(fmt.Sprintf("kbot_bitcoin_%s", payload))

	// Get or create an Int64Counter instrument with the name "kbot_bitcoin_<payload>"
	counter, _ := meter.Int64Counter(fmt.Sprintf("kbot_bitcoin_%s", payload))

	// Add a value of 1 to the Int64Counter
	counter.Add(ctx, 1)
}

// Initialize OpenTelemetry
func initMetrics(ctx context.Context) {

	// Create a new OTLP Metric gRPC exporter with the specified endpoint and options
	exporter, err := otlpmetricgrpc.New(
		ctx,
		otlpmetricgrpc.WithEndpoint(MetricsHost),
		otlpmetricgrpc.WithInsecure(),
	)

	if err != nil {
		// Handle the error, such as logging or returning an error message
		log.Fatalf("Failed to create exporter: %v", err)
	}
	// Define the resource with attributes that are common to all metrics.
	// labels/tags/resources that are common to all metrics.
	resource := resource.NewWithAttributes(
		semconv.SchemaURL,
		semconv.ServiceNameKey.String(fmt.Sprintf("kbot_%s", appVersion)),
	)

	// Create a new meterProvider with the specified resource and reader
	mp := sdkmetric.NewMeterProvider(
		sdkmetric.WithResource(resource),
		sdkmetric.WithReader(
			// collects and exports metric data every 10 seconds.
			sdkmetric.NewPeriodicReader(exporter, sdkmetric.WithInterval(10*time.Second)),
		),
	)

	// Set the global MeterProvider to the newly created MeterProvider
	otel.SetMeterProvider(mp)

}

func init() {

	initMetrics(context.Background())
	rootCmd.AddCommand(kbotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// versionCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// versionCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
