# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "管理者",
             email: "admin@admin.com",
             affiliation: "管理者",
             password:              "aiueok",
             password_confirmation: "aiueok",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "上長",
             email: "superior@superior.com",
             affiliation: "上長",
             password:              "kakikukeko",
             password_confirmation: "kakikukeko",
             employee_number: "1",
             user_card_id: "1",
             specified_work_time: "08:00",
             specified_end_time: "18:00",
             basic_work_time: "07:30",
             superior: true,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  "一般ユーザー",
             email: "rails@railstutorial.org",
             affiliation: "サンプル一般",
             password: "foobar",
             password_confirmation: "foobar",
             employee_number: "2",
             user_card_id: "2",
             specified_work_time: "08:00",
             specified_end_time: "18:00",
             basic_work_time: "07:30",
             activated: true,
             activated_at: Time.zone.now)