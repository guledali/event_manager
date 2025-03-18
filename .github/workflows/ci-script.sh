#!/bin/bash
set -e

echo "Setting up CI environment for system tests..."

# Skip asset compilation since JS tests are skipped
echo "Skipping asset compilation for CI environment..."

echo "Starting tests..."

# Run the tests with more verbose output
RAILS_ENV=test bin/rails db:test:prepare test test:system TESTOPTS="--verbose"
