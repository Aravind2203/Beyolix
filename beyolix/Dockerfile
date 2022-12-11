FROM python:3.10

# Set the working directory to /app
WORKDIR /src

# Copy the current directory contents into the container at /app
ADD ./ /src

# Install any needed packages specified in requirements.txt 
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 8000
#COPY . .
# Run app.py when the container launches
CMD ["python", "api.py"]
