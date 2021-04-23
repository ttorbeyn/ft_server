if (( $(ps -ef | grep -v grep | grep nginx | wc -l) > 0 ))
then
    if [ "$AUTOINDEX" = "off" ] ;
    then cp /tmp/nginx_autoindex_off.config /etc/nginx/sites-available/default ;
    else cp /tmp/nginx_autoindex_on.config /etc/nginx/sites-available/default ; fi
service nginx reload
else
    if [ "$AUTOINDEX" = "off" ] ;
    then cp /tmp/nginx_autoindex_off.config /etc/nginx/sites-available/default ;
    else cp /tmp/nginx_autoindex_on.config /etc/nginx/sites-available/default ; fi
fi
