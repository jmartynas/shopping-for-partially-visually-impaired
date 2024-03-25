package api

import (
	"bytes"
	"context"
	"errors"
	"net/http"
	"os"

	"github.com/Azure/azure-sdk-for-go/sdk/storage/azblob"
)

func GetImage(w http.ResponseWriter, r *http.Request) error {
	if r.Method != http.MethodGet {
		return apiError{Err: "invalid method", Status: http.StatusMethodNotAllowed}
	}

	imageName := r.URL.Query().Get("image")

	if imageName == "" {
		return apiError{Err: "Wrong request", Status: http.StatusBadRequest}
	}

	client, err := GetClient()
	if err != nil {
		return err
	}

	data, err := downloadData(client, imageName)
	if err != nil {
		return err
	}

	_, err = w.Write(data.Bytes())
	if err != nil {
		return err
	}

	return nil
}

func GetClient() (*azblob.Client, error) {
	url := "https://pvpfiles.blob.core.windows.net/"

	accountName, ok := os.LookupEnv("AZURE_STORAGE_ACCOUNT_NAME")
	if !ok {
		return nil, errors.New("AZURE_STORAGE_ACCOUNT_NAME environment variable is not set")
	}

	accountKey, ok := os.LookupEnv("AZURE_STORAGE_PRIMARY_ACCOUNT_KEY")
	if !ok {
		return nil, errors.New("AZURE_STORAGE_PRIMARY_ACCOUNT_KEY environment variable is not set")
	}

	cred, err := azblob.NewSharedKeyCredential(accountName, accountKey)
	if err != nil {
		return nil, err
	}

	client, err := azblob.NewClientWithSharedKeyCredential(url, cred, nil)
	return client, nil
}

func downloadData(client *azblob.Client, imageName string) (*bytes.Buffer, error) {
	ctx := context.Background()

	container, ok := os.LookupEnv("AZURE_CONTAINER")
	if !ok {
		return nil, errors.New("AZURE_CONTAINER environment variable is not set")
	}

	get, err := client.DownloadStream(ctx, container, imageName, nil)
	if err != nil {
		return nil, err
	}

	data := &bytes.Buffer{}
	retryRead := get.NewRetryReader(ctx, &azblob.RetryReaderOptions{})
	_, err = data.ReadFrom(retryRead)
	if err != nil {
		return nil, err
	}

	err = retryRead.Close()
	if err != nil {
		return nil, err
	}

	return data, nil
}
