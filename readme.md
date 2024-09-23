## Project Overview:
We'll set up a simple Node.js application, write tests for it, and create a Jenkins pipeline to:

- Install dependencies.
- Run tests.
- Build the app.
- Deploy it (optionally).

## Steps:

**1. Set Up Node.js Project**
First, create a simple Node.js app.
- **Initialize Node.js project:**

```bash
mkdir nodejs-jenkins-demo
cd nodejs-jenkins-demo
npm init -y

```

- **Create a basic app:** Create a file called ``app.js:``

```javascript
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.send('Hello, Jenkins Pipeline!');
});

const server = app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

module.exports = { app, server };

```

- **Install dependencies:** Install Express for this simple web server.

```bash
npm install express
```

**2. Add Testing**
Write some tests using Jest.

-  **Install Jest:**

```bash
npm install jest supertest --save-dev
```

-  **Create a test:** Add a ``test/app.test.js`` file:


```javascript
const request = require('supertest');
const { app, server } = require('../app');

describe('GET /', () => {
    afterAll(() => {
        server.close();  // Close the server after tests
    });

    it('should return "Hello, Jenkins Pipeline!"', async () => {
        const res = await request(app).get('/');
        expect(res.statusCode).toEqual(200);
        expect(res.text).toBe('Hello, Jenkins Pipeline!');
    });
});

```


- **Update package.json** to include test script: In package.json, add this:

```json
"scripts": {
    "start": "node app.js",
    "test": "jest",
    "build": "echo 'No build step required'"
}
```

- **Run the tests:**

```bash
npm test

```


## 3. Create Jenkins Pipeline

Now, we’ll create a **Jenkinsfile** that Jenkins will use to build, test, and deploy this Node.js app.

- Create a **Jenkinsfile** in your project root:

```groovy
pipeline {
    agent any

    environment {
        NODE_ENV = 'production'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                echo 'Installing dependencies...'
                sh 'npm install'
            }
        }
        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                sh 'npm test'
            }
        }
        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'npm run build' // Add your build command if needed
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
                // Add your deployment commands here, e.g., Docker, Kubernetes, etc.
                // e.g., sh 'scp -r * user@server:/path/to/app'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs!'
        }
    }
}

```



## 4. Configure Jenkins

Once your project is ready, we need to configure Jenkins to work with your Node.js project.

**Set Up Jenkins:**


- Go to your Jenkins dashboard.
- Click **New Item > Pipeline** and give it a name.
- Under **Pipeline** section, select **Pipeline script from SCM.**
- Choose **Git** and enter your repository URL where your project is stored (e.g., GitHub or GitLab).
- Ensure that your ``Jenkinsfile`` is in the root directory.


**Install Node.js in Jenkins:**

- Install the **NodeJS Plugin** in Jenkins.
- Go to **Manage Jenkins > Global Tool Configuration.**
- Add Node.js under **NodeJS installations**, specify the version, and configure it for your Jenkins jobs


**Run the Pipeline:**

- Click **Build** Now to trigger the pipeline.
- Jenkins will fetch the code, install dependencies, run tests, build, and (optionally) deploy your Node.js app.
