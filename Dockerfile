# Use an official Node.js runtime as a parent image
FROM node:16-alpine

# Set the working directory inside the Docker container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy the rest of the application code
COPY . .

# Expose the port on which your app will run
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
