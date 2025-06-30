# coding: utf-8
FactoryBot.define do
  factory :certificate do
    operator_fqdn { 'test.medical-oss.org' }
    operator_name { 'KOBAYASHI Shinji' }
    operator_email { 'skoba@moss.gr.jp' }
    operator_affiliation { '医療オープンソースソフトウェア協議会' }
    operator_software { 'nginx 1.18.0' }
    serial_no { '2523387705629275603' }
    revocation_reason_code { '5' }
    revocation_reason { 'サーバ使用中止' }
  end
end
