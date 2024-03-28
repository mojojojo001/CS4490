# Use an official GCC image as a parent image
FROM gcc:latest

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Compile the C program
RUN gcc -o my_program main.c

# Run the compiled program when the container launches
CMD ["./my_program"]
