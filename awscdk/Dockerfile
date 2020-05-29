from node:alpine

ARG AWS_REGION="us-west-2"

ENV AWS_REGION=$AWS_REGION

RUN apk update \
    && apk add --no-cache ca-certificates\
        bash \
        curl \
        python3 \
    && rm -rf /var/cache/apk/*

RUN pip3 install --upgrade pip \
    && pip3 install awscli \
    && npm install -g aws-cdk@1.36.1 \
    && mkdir -p /home/root/.aws 

ONBUILD COPY package*json .npmrc* /app/
ONBUILD RUN cd /app && npm install 

# Now copy in the full code for the app
ONBUILD COPY . /app
ONBUILD RUN npm run build && rm -rf node_modules && npm install --production 
    

# Set our workdirectory to the app and start with npm
WORKDIR /app
EXPOSE 3000

CMD ["endpoint.sh"]

