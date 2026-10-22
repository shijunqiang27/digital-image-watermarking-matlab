# MATLAB Digital Image Watermarking System

[简体中文](README.md)

This repository contains a MATLAB App Designer graduation project for digital image watermarking. Its main application embeds and extracts a watermark in grayscale images using a combination of **Haar Discrete Wavelet Transform (DWT), Discrete Cosine Transform (DCT), and Singular Value Decomposition (SVD)**. It also includes experiments with noise, filtering, cropping, rotation, and JPEG compression.

## Features

- Embed and extract a binary watermark in a host image
- Scramble the watermark with the Arnold transform before embedding
- Display the original, watermarked, and attacked images, along with the extracted watermark
- Calculate PSNR, SSIM, and normalized correlation (NC)
- Apply common image attacks and inspect the extraction results
- Explore additional MATLAB experiments for DCT, DWT, SVD, Arnold scrambling, and Logistic chaos

## Interface and Example Results

The main interface displays the host image, watermark, watermarked image, and extracted watermark.

![Watermark embedding and extraction interface](docs/images/watermark-workflow.png)

The performance-test screenshot shows one experiment using the Hallway host image: PSNR = 42.4343 dB, SSIM = 0.97811, and NC = 0.99913. These are results from a single example, not guaranteed values for other images or attack conditions.

![Example watermark performance test](docs/images/embedding-extraction-result.png)

The application also provides common image attacks for inspecting watermark extraction after image degradation.

![Image attack test examples](docs/images/attack-examples.png)

## Main Algorithm

The main application follows this embedding pipeline:

1. Scramble the **64 × 64** binary watermark with 10 Arnold-transform iterations.
2. Apply a two-level Haar DWT to the **512 × 512** grayscale host image and select the second-level high-frequency subband **HH2**.
3. Find the **64 × 64** region with the highest entropy in **HH2**, then apply DCT and SVD to that region.
4. Add the scrambled watermark singular values to the host singular values using an embedding strength of **α = 0.05**; inverse transforms reconstruct the watermarked image.
5. During extraction, recover the watermark using the stored embedding parameters. Rotation-attack tests also use SURF feature matching and rotation correction.

## Getting Started

### Requirements

- MATLAB Desktop with App Designer
- Image Processing Toolbox
- Wavelet Toolbox
- Computer Vision Toolbox (required for SURF-based rotation correction)

The repository does not specify a particular MATLAB release. Toolbox requirements depend on which features you run.

### Launch the Main App

1. In MATLAB, set the current folder to the repository's **app/** directory.
2. Open **DIP_sjq.mlapp** in App Designer.
3. Select **hallway.jpg** with **Open Host Image**, then select **水印(二值).bmp** with **Open Watermark Image**.
4. Click **Embed Watermark**, then **Extract Watermark** to view the result.
5. Click **Watermark Performance Test** to open the test interface, calculate metrics, and apply image attacks.

The sample inputs are included: **hallway.jpg** is a **512 × 512** grayscale image, and **水印(二值).bmp** is a **64 × 64** binary image. The main application is designed for these dimensions; keep the input size and image type compatible when using other files.

## Repository Layout

~~~text
app/                    App Designer applications and sample images
experiments/dct/        MATLAB Live Scripts, experiments, and result images
source/appdesigner/     Readable MATLAB source exported from .mlapp files
tools/                  App source export utility
docs/images/            Screenshots used in this README
~~~

Open the experiment scripts in MATLAB from **experiments/dct/**. The **.mlapp** files are the editable App Designer applications; the **.m** files in **source/appdesigner/** are provided for source inspection and comparison.
