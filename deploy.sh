#!/bin/sh
# Vanguard — atualiza arquivos no container nginx
BASE=https://raw.githubusercontent.com/subdiretormnmsgm-commits/vanguard/master
HTML=/usr/share/nginx/html

update() {
  curl -sL "$BASE/$1" -o "/tmp/vg_deploy_file"
  cp /tmp/vg_deploy_file "$HTML/$1"
  echo "OK: $1"
}

update index.html
update js/quiz.js
update js/closer-machine.js
update js/outbound-engine.js
update js/hive-mind.js
update js/sovereign-playbook.js
update assets/css/v26-design-unification.css
update score/index.html
update census/index.html
update dashboard/index.html
update intelligence/index.html
update marketplace/index.html
update marketplace/creator.html
update cockpit/index.html
update saas/dashboard.html
update preview/index.html

# Atualiza nginx.conf e recarrega
curl -sL "$BASE/infra/nginx.conf" -o /tmp/nginx.conf
cp /tmp/nginx.conf /etc/nginx/conf.d/default.conf
nginx -s reload
echo "OK: nginx.conf recarregado"

echo "Deploy concluido!"
