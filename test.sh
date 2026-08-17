#!/bin/bash
if grep -q "CI/CD Pipeline Demo" index.html; then
  echo "TEST PASSED"
  exit 0
else
  echo "TEST FAILED"
  exit 1
fi
