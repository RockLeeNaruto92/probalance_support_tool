# Format spread sheet file

https://docs.google.com/spreadsheets/d/1PYGseGc6sMmReWG2PSm3ExFOwMwFtxxz7BDjOZ0n50o/edit#gid=781910245

# Setup

https://github.com/RockLeeNaruto92/craw_tutorial

Setup ruby và chromedrive như hướng dẫn trên

# Config

Format các file config ở đây:

https://drive.google.com/drive/folders/1a0DEUuUEEs2YgK2eKkIc0z1Rq5RH_swQ

Download các file này về và cho vào thư mục config

- sheet_config.yaml:
  - *sheet_key*: id của file spreadsheet quản lý
- create_cloud.yaml
  - *base_url*:
    - trường hợp chạy thực tế trên create-cloud production thì link là: https://member.createcloud.jp
    - trường hợp test cái tool này trên STG thì link là: https://membernew.createcloud.jp
  - *account*: login account
    - *email*
    - *password*
- google_drive_config.json: Chứa các thông tin client_id, client_secret để connect đến google drive

# Run

cd support_tool
ruby main.rb
