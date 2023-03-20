#解压源码

# 默认安装目录

依赖

yum install -y gcc pcre pcre-devel zlib zlib-devel openssl openssl-devel

# 安装脚本

```bash
#!/bin/bash

function download(){

   wget -P /usr/local/nginx wget [http://nginx.org/download/](http://nginx.org/download/nginx-1.14.1.tar.gz)nginx-1.22.0.tar.gz
	 if test -e /usr/local/nginx/nginx-1.12.0.tar.gz;then
			return 0
   else
			return 1
	 fi
}

function install(){
	tar xf /usr/local/nginx/nginx-1.12.0.tar.gz -C /usr/local/nginx/ --strip-components 1

	rm -f /usr/local/nginx/nginx-1.12.0.tar.gz
  echo "unzip source code and remove the package"	
	cd /usr/local/nginx/
	./configure
	sleep 1
	make && make all
  if test $? -ne 0;then
		echo "install failed due to some error"
		return 1
	else
    return 0
  fi

}

if test -e /usr/local/nginx/nginx-1.12.0.tar.gz;then
echo "package have downloaded"
else
download
fi

if test $? -ne 0;then
	echo "error happened during download"
	exit 1
fi

install

./configure --prefix=/usr/local/nginx --user=zdsoft --group=zdsoft --with-compat --with-debug --with-file-aio --with-google_perftools_module --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_degradation_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_perl_module=dynamic --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_xslt_module=dynamic --with-mail=dynamic --with-mail_ssl_module --with-pcre --with-pcre-jit --with-stream=dynamic --with-stream_ssl_module --with-stream_ssl_preread_module --with-threads --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'
```

./configure --prefix=/usr/local/nginx --user=zdsoft --group=zdsoft --with-compat --with-debug --with-file-aio --with-google_perftools_module --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_degradation_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_perl_module=dynamic --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_xslt_module=dynamic --with-mail=dynamic --with-mail_ssl_module --with-pcre --with-pcre-jit --with-stream=dynamic --with-stream_ssl_module --with-stream_ssl_preread_module --with-threads --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie’