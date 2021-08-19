#!/bin/bash
zip udagram.zip index.html
aws s3 cp udagram.zip s3://my-467989809503-bucket/udagram.zip