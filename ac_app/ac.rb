require 'rubygems'
require 'sinatra'
require 'haml'

keyHash = Hash.new

configure do
  enable :sessions
  set :session_secret, '61c191ce644fbfbc7a1340fb11f6cb9bdcc46da6'
  set :environment, :production
end

get '/' do
  haml :index, :locals => {:userInfo => keyHash[session.id], :voteInfo => getVoteInfo(keyHash)}
end

post '/' do
  keyHash[session.id] = [params[:name], params[:ac_vote], Time.now];
  haml :index, :locals => {:userInfo => keyHash[session.id], :voteInfo => getVoteInfo(keyHash)}
end

def getVoteInfo(keyHash)
  totalTrues = 0
  totalValidVotes = 0
  voters = Array.new

  keyHash.each do |k, v|
    
    if (Time.now - v[2]) < 10800
      totalValidVotes += 1
      totalTrues +=1 if v[1] == "1"
      voters.push(v[0])
    end
  end

  return [totalTrues,totalValidVotes, voters]
end