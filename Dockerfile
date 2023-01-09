FROM alpine
#FROM arm32v7/alpine

# Install cron
RUN apk update \
    && apk add --no-cache dcron curl bind-tools

# Copy script
COPY script.sh /
COPY entrypoint.sh /

# Make script executable
RUN chmod +x /script.sh
RUN chmod +x /entrypoint.sh

# Add cron task
RUN echo "*/5 * * * * /script.sh" >> /etc/crontabs/root

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD crond -f

