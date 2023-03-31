# A dockerfile must always start by importing the base image.
# We use the keyword 'FROM' to do that.
# In our example, we want import the python image.
# So we write 'python' for the image name and 'latest' for the version.

FROM python:latest

# create a new directory first where the image will be stored
RUN mkdir /build
WORKDIR /build

# In order to launch our python code, we must import it into our image.
# We use the keyword 'COPY' to do that.
# The first parameter app is the name of the file on the host.
# The second parameter '/build' is the path where to put the file on the image.
# Here we put the file at the image root folder.

COPY app /build

#copy the text file as well to /build folder
COPY app/requirements.txt /build

RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r requirements.txt

EXPOSE 5000

# We need to define the command to launch when we are going to run the image.
# We use the keyword 'CMD' to do that.
# The following command will execute "python ./build/app.py".
CMD [ "python", "app.py" ]
