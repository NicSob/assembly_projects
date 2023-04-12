# Fibonacci, SHA-1, and Simplified printf in Assembly

This repository contains three separate assembly language projects: a Fibonacci calculator with user interaction and efficient memory management, an implementation of the SHA-1 hash function, and a simplified printf function. Each of these projects is designed to help practice and combine the skills learned in previous assignments.

## Table of Contents

- [Fibonacci Calculator](#fibonacci-calculator)
- [SHA-1 Hash Function Implementation (Mentioned in CV)](#sha-1-hash-function-implementation)
- [Simplified printf](#simplified-printf)

## Fibonacci Calculator

The Fibonacci calculator project contains an assembly implementation of a simple Fibonacci calculator with user interaction and efficient memory management. It implements both recursive and iterative methods for calculating Fibonacci numbers and allows the user to choose between them. The program also saves previously calculated Fibonacci numbers to avoid redundant calculations.

**Features:**

- Recursive and iterative Fibonacci calculation methods
- User interaction for choosing the desired Fibonacci number
- Efficient memory management to store previously calculated Fibonacci numbers

## SHA-1 Hash Function Implementation

In this project, you will find an assembly implementation of the SHA-1 hash function. This implementation reads input data, divides it into 512-bit chunks, and processes each chunk to calculate the hash value.

**Features:**

- Processes input data in 512-bit chunks
- Implements the core SHA-1 algorithm
- Combines the results of each chunk to produce the final hash value

## Simplified printf

The simplified printf project contains an assembly implementation of a printf-like function with a limited set of format specifiers. It supports printing signed and unsigned integers, null-terminated strings, and percent signs.

**Features:**

- Handles variable number of arguments
- Supports the following format specifiers:
  - `%d`: Print a signed integer in decimal
  - `%u`: Print an unsigned integer in decimal
  - `%s`: Print a null-terminated string
  - `%%`: Print a percent sign

## Getting Started

To get started with these projects, clone the repository and follow the specific instructions for each project.

```sh
git clone https://github.com/yourusername/assembly-projects.git
cd assembly-projects

Each project has its own directory containing the assembly source code and a Makefile to build and run the project.

cd fibonacci-calculator
make
./fibonacci

cd ../sha1-hash-implementation
make
./sha1

cd ../simplified-printf
make
./simplified_printf
