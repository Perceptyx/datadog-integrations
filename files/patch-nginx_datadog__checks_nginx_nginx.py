--- nginx/datadog_checks/nginx/nginx.py.orig	2020-03-30 17:43:00 UTC
+++ nginx/datadog_checks/nginx/nginx.py
@@ -218,6 +218,8 @@ class Nginx(AgentCheck):
         if version:
             if '/' in version:
                 version = version.split('/')[1]
+            else:
+                version = '0.0.0'
             self.set_metadata('version', version)
 
             self.log.debug(u"Nginx version `server`: {}".format(version))
