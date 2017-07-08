#GhostMiner - by: João Vítor Penna Reis
#G.H.O.S.T Miner- GitHub Open Source Total Miner
require 'octokit'
require 'thread'
require 'benchmark'
require 'fileutils'
require_relative 'pool'
require 'json'

class Main
  def initialize(token)
    Octokit.auto_paginate = true
    miner1 = UserMiner.new(token)
  end
end

class Miner
  attr_accessor :client

  def initialize(token)
    @client = Octokit::Client.new(:access_token => token)
  end
  def assembleDirs
  end
  def populateData
  end
end

class UserMiner < Miner
  attr_accessor :users

  def initialize(token)
    super
    @users = @client.org_members("#{ORG}")
    assembleDirs
    populateData
  end

  def assembleDirs
    super
    for i in @users
      FileUtils.mkdir_p(getPath(i))
    end
  end

  def getPath(user,extension="")
    return "#{ORG}/users/#{user[:login]}/#{extension}"
  end

  def populateData
    super
    pooler = Pool.new(400)
    for i in @users
      if File.directory?("#{ORG}/users/#{i[:login]}")
        File.write("#{getPath(i)}/profile_#{Date.today}.txt", JSON.pretty_generate(i.to_h))
        pooler.schedule(i,@client) do
          #pulls = @client.search_issues({ :type => "pr", :author => "#{i[:login]}"})#"type:pr+author:#{i[:login]}")
          puts i[:login]
          pulls = "teste"
          FileUtils.mkdir_p(getPath(i,"pull_requests"))
          sleep(0.5)
          #File.write("#{getPath(i,"pull_requests")}/pr_#{Date.today}.txt", JSON.pretty_generate(pulls.to_h))
          File.write("#{getPath(i,"pull_requests")}/pr_#{Date.today}.txt", pulls)
        end
      end
    end
  end
end

ORG = 'org here'

m = Main.new("token here")
while true

end