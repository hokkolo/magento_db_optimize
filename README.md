**Optimize Magento 1 and Magento 2 Database**

There are many database tables in Magento 1 and Magento 2 engine, that can eat up the server diskspace. 

This is a bash script to truncate all the unwanted tables in the Magento database and reduce the size of the Magento Database. 

The script is currently optimized to run on a cPanel server, this can be changed by updating the "HTTP_CONF" in the scrpt to the path of your web server configuration.

Define the table size at "SIZE"
