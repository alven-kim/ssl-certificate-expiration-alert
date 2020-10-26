ssl-certification-expire-alert
==============================

# Concept
 - SSL 인증서의 만료일이 D-Day 1 Month일 경우 설정한 Mail로 Alert

# Dependency
 - package install openssl
 - 스크립트 실행 노드에서 메일 전송이 가능해야 함

# How to use
 - fqdn.txt에 SSL 인증서 만료를 체크할 도메인 입력(FQDN 형식)
 - mail_addreses.txt에 메일을 받을 메일주소 입력
 - ssl_cert_check_alert.sh 해당 스크립트를 cron에 매일 실행시키도록 설정

# etc - Summary Check
 - ./ssl_cert_check.sh [FQDN]
```bash
root# ./ssl_cert_check.sh www.naver.com
notAfter=Jun  8 12:00:00 2022 GMT
```

## See Also
 - man openssl
 - openssl help
