# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "管理者",
             email: "attendance@gmail.com",
             affiliation: "管理者",
             employee_number: "9999",
             uid: "9999",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "上長A",
             email: "attendance-system1@gmail.com",
             affiliation: "上長",
             password: "foobar",
             password_confirmation: "foobar",
             employee_number: "1",
             uid: "1",
             designated_work_start_time: "08:00",
             designated_work_end_time: "18:00",
             basic_work_time: "07:30",
             superior: true,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  "上長B",
             email: "attendance-system2@gmail.com",
             affiliation: "上長",
             password: "foobar",
             password_confirmation: "foobar",
             employee_number: "2",
             uid: "2",
             designated_work_start_time: "08:00",
             designated_work_end_time: "18:00",
             basic_work_time: "07:30",
             superior: true,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  "一般ユーザーA",
             email: "attendance-system3@gmail.com",
             affiliation: "サンプル一般",
             password: "foobar",
             password_confirmation: "foobar",
             employee_number: "3",
             uid: "3",
             designated_work_start_time: "08:00",
             designated_work_end_time: "18:00",
             basic_work_time: "07:30",
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  "一般ユーザーB",
             email: "attendance-system4@gmail.com",
             affiliation: "サンプル一般",
             password: "foobar",
             password_confirmation: "foobar",
             employee_number: "4",
             uid: "4",
             designated_work_start_time: "08:00",
             designated_work_end_time: "18:00",
             basic_work_time: "07:30",
             activated: true,
             activated_at: Time.zone.now)

Base.create!(base_name: "拠点A",
             base_type: "勤怠A")
             
Base.create!(base_name: "拠点B",
             base_type: "勤怠B")