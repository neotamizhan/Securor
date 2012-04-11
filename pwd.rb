require 'gibberish'
require 'date'
require 'highline/import'


class Securor  
  attr_accessor :key, :cipher


  def initialize
    #print "Please enter the master password : "
    @key = get_password().strip    
    @cipher = Gibberish::AES.new(@key)
  end

  def get_password(prompt="Enter Master Key : ")
     ask(prompt) {|q| q.echo = false}
  end

  def fetch_pwd    
    
      pwd = File.open('pwd.dat','r').readlines[0] 

    begin
      pwd = @cipher.decrypt(pwd)
    rescue
      puts 'Password was invalid.'
      return
    end

    pwd
  end

  def put_pwd
    print 'Please enter the password :'
    pwd = gets 
    pwd = @cipher.encrypt(pwd)
    File.open('pwd.dat','w') {|f| f.puts pwd}
    puts 'Password has been saved. :)'
  end

  def make_pwd
    t = Date.today
    pwd =  t.strftime('%B') + t.day.to_s + t.year.to_s
    pwd = @cipher.encrypt(pwd)
    File.open('pwd.dat','w') {|f| f.puts pwd}

    pwd
  end

  def get_pwd
    print 'What do you want to do? [make/put/fetch] : '
    mode = gets

    case mode.chomp.downcase.to_sym
      when :make then make_pwd
      when :put then put_pwd
      when :fetch then fetch_pwd
      else "Invalid mode"
    end
  end

end

puts Securor.new.get_pwd