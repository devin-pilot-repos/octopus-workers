#!/bin/bash

echo "-----------------------------------"
echo "Setting up environment variables..."

export ServerApiKey=$SERVERAPIKEY

echo "API-Key Hint: $(echo $ServerApiKey | cut -c5-8)"

echo "-----------------------------------"
