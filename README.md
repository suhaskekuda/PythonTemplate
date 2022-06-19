# PythonTemplate

This will be the template for all future python projects.

How to Begin
Here's a list of recommended next steps to help you get started with application development.

```
git clone https://github.com/suhaskekuda/PythonTemplate.git
cp -r PythonTemplate <ProjectName>
cd <ProjectName>
rm -rf .git
```

Create a working environment
The commands below will build a virtual environment and upgrade pip to the most recent version.
This will also install the flask package.

```
bin\setup.sh setup
```

The file *config/app.setting.json* governs application parameters.

You're all set to code now.

Once the code is written, it is to be inspected for sanity and vulnerabilities.
```
bin/sanity.sh 
```
The reports will be captured in the **report** folder.