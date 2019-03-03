FROM alpine:latest

LABEL maintainer="Leo Przybylski <r351574nc3 at gmail.com>"

RUN apk update \
    && apk add --no-progress --no-cache nodejs

ONBUILD COPY package*json .npmrc* /app/
ONBUILD RUN cd /app && npm install 

# Now copy in the full code for the app
ONBUILD COPY . /app
ONBUILD RUN npm run build && rm -rf node_modules && npm install --production 
    

# Set our workdirectory to the app and start with npm
WORKDIR /app
EXPOSE 3000

USER 1001

CMD ["npm", "start" ]


