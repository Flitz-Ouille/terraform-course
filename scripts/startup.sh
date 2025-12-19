#!/bin/bash
apt-get update -y
apt-get install -y nginx

cat > /var/www/html/index.html << 'EOF'
<html>
  <head><title>Terraform Local</title></head>
  <body>
    <h1>Instance gérée par Terraform</h1>
    <p>Tout fonctionne.</p>
  </body>
</html>
EOF

systemctl enable nginx
systemctl restart nginx
