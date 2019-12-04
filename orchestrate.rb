# frozen_string_literal: true

require 'sinatra'
require 'httparty'
# require 'pry'
# require 'bcrypt'

before do
  request.body.rewind
  @request_payload = JSON.parse(request.body.read, symbolize_names: true)
  @request_payload.each { |name, value| instance_variable_set("@#{name.to_s.tr('-', '_')}", value) }
end

post '/orchestrate' do
  payload = create_json_to_send(@fm_question, nil, nil)
  content_type :json
  payload.to_json
end

def generate_json_string(data)
  JSON.generate(data)
end

def create_json_to_send(text, expression = nil, _html = nil)
  answer_body = {
    "answer": text,
    "instructions": {
      "expressionEvent": [
        expression
      ],
      "emotionalTone": [
        {
          "tone": 'happiness', # desired emotion in lowerCamelCase
          "value": 0.2, # number, intensity of the emotion to express between 0.0 and 1.0
          "start": 2, # number, in seconds from the beginning of the utterance to display the emotion
          "duration": 4, # number, duration in seconds this emotion should apply
          "additive": false, # boolean, whether the emotion should be added to existing emotions (true), or replace existing ones (false)
          "default": true # boolean, whether this is the default emotion
        }
      ]
      # "displayHtml": {
      #     "html": html
      # }
    }
  }

  body = {
    "answer": generate_json_string(answer_body),
    "matchedContext": '',
    "conversationPayload": generate_json_string("sessionId": @sessionId)
  }
  body
end
