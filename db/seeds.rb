# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(id: 1,
             name:  "管理者",
             affiliation: "管理者",
             employee_number: "admin",
             password:              "aiueok",
             password_confirmation: "aiueok",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(id: 2,
             name:  "上長A",
             affiliation: "上長",
             password: "foobar",
             password_confirmation: "foobar",
             employee_number: "1",
             user_card_id: "1",
             specified_work_time: "08:00",
             specified_end_time: "18:00",
             basic_work_time: "07:30",
             superior: true,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(id: 3,
             name:  "上長B",
             affiliation: "上長",
             password: "foobar",
             password_confirmation: "foobar",
             employee_number: "2",
             user_card_id: "2",
             specified_work_time: "08:00",
             specified_end_time: "18:00",
             basic_work_time: "07:30",
             superior: true,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(id: 4,
             name:  "一般ユーザーA",
             affiliation: "サンプル一般",
             password: "foobar",
             password_confirmation: "foobar",
             employee_number: "3",
             user_card_id: "3",
             specified_work_time: "08:00",
             specified_end_time: "18:00",
             basic_work_time: "07:30",
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(id: 5,
             name:  "一般ユーザーB",
             affiliation: "サンプル一般",
             password: "foobar",
             password_confirmation: "foobar",
             employee_number: "4",
             user_card_id: "4",
             specified_work_time: "08:00",
             specified_end_time: "18:00",
             basic_work_time: "07:30",
             activated: true,
             activated_at: Time.zone.now)