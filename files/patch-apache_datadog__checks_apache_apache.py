--- apache/datadog_checks/apache/apache.py.orig	2020-03-30 17:44:02 UTC
+++ apache/datadog_checks/apache/apache.py
@@ -111,7 +111,11 @@ class Apache(AgentCheck):
                 )
 
     def _collect_metadata(self, value):
-        raw_version = value.split(' ')[0]
-        version = raw_version.split('/')[1]
+        if len(value.split(' ')) == 1:
+            # ServerTokens are off
+            version = "servertokens-off"
+	else:
+            raw_version = value.split(' ')[0]
+            version = raw_version.split('/')[1]
         self.set_metadata('version', version)
         self.log.debug("found apache version %s", version)
