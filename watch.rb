#!/usr/bin/env ruby

require "octokit"
require "thor"

class WatchCLI < Thor
  class_option :token, :type => :string

  desc "list <regex>", "lists all repos, useful to test your watch regex"
  def list(regex='.*')
    get_repos().each do |repo|
      puts repo.full_name if /#{regex}/.match(repo.full_name)
    end
  end

  desc "watched <regex>", "show all watched repos, useful to test your unwatch regex"
  def watched(regex='.*')
    get_subscriptions().each do |repo|
      puts repo if /#{regex}/.match(repo)
    end
  end

  desc "watch <regex>", "watch all repos matching your regex"
  def watch(regex)
    subscriptions = get_subscriptions()
    get_repos().each do |repo|
      if !subscriptions.include?(repo.full_name) and /#{regex}/.match(repo.full_name)
        puts "Subscribing to #{repo.full_name}..."
        get_octokit().update_subscription(repo.full_name, {subscribed: true})
      end
    end
  end

  desc "unwatch <regex>", "unwatch all repos matching your regex"
  def unwatch(regex)
    subscriptions = get_subscriptions()
    get_repos().each do |repo|
      if subscriptions.include?(repo.full_name) and /#{regex}/.match(repo.full_name)
        puts "Unsubscribing from #{repo.full_name}..."
        get_octokit().delete_subscription(repo.full_name)
      end
    end
  end

  no_commands {
    def get_octokit
      if !options[:token]
        puts "Please specify --token"
        exit(1)
      end
      client = Octokit::Client.new(:access_token => options[:token])
      client.auto_paginate = true
      return client
    end

    def get_repos
      client = get_octokit

      repos = client.repositories(client.user.login)

      orgs = client.organizations()
      orgs.each do |org|
        client.organization_repositories(org.login).each do |repo|
          repos << repo
        end
      end

      return repos
    end

    def get_subscriptions
      client = get_octokit

      return client.subscriptions(client.user.login).map { |repo| repo.full_name }
    end
  }
end

WatchCLI.start(ARGV)
