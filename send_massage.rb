require "pony"
require "io/console"

sender = "" #your post 

puts "Введите пароль от почты #{sender} "

password = STDIN.noecho(&:gets).chomp

puts "Кому отправить письмо?" 

reciever = STDIN.gets.chomp

loop do

	if (reciever =~ /^[0-9a-z._]+@[a-z.0-9]+\.[a-z]+$/)
		break
	else
		puts "Ошибка!Введите валидный адрес"
		reciever = STDIN.gets.chomp
	end
end

puts "Какая тема письма?"
topic_mail = STDIN.gets.chomp
puts "Что написать в письме"
content_mail = STDIN.gets.chomp

begin 
Pony.mail(
	{
		:subject => topic_mail,
		:body => content_mail,
		:to => reciever,
		:from => sender,

		:via => :smtp,

		via_options: {
		  address: 'smtp.gmail.com',
		  port: '587',
		  enable_starttls_auto: true,
		  user_name: sender,
		  password: password,
		  authentication: :plain,
		}
  
	}
		)

puts 'Письмо успешно отправлено' 

rescue NoMethodError
	puts 'Неправильно указаны параметры письма'

rescue Net::SMTPSyntaxErrror => e
	puts 'Неправильно введен ящик получателя ' + e.message
rescue Net::OpenTimeout => e
	puts 'Ошибка времени выполнения,проверьте соединение с интернетом или параметры порта : ' + e.message

rescue SocketError
	puts 'Не удалось подключиться к серверу,проверьте параметры '

rescue Net::SMTPAuthenticationError => e
	puts 'Неправильно введен логин пароль : ' + e.message

ensure
	puts 'Процесс отправки закончен' 
end




