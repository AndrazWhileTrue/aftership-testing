# frozen_string_literal: true
require 'rubygems'
require 'aftership'
require 'dotenv'

Dotenv.load

# Response data format
# {
#     "meta": {
#         "code": 401,
#         "message": "Invalid API Key.",
#         "type": "Unauthorized"
#     },
#     "data": {
#         "couriers": [
#             {},
#             {},
#             {}
#         ]
#     }
# }

class Tracker 
    def initialize()
        AfterShip.api_key = ENV['API_KEY']
    end

    def get_activated_curriers()
        AfterShip::V4::Courier.get
    end

    def get_all_curriers()
        AfterShip::V4::Courier.get_all
    end

    def detect_currier(tracking_number)
        AfterShip::V4::Courier.detect({
            :tracking_number => tracking_number 
        })
    end

    def create_tracking(slug, tracking_number)
        data = {
            :slug => slug,
            :title => 'Order title',
            :smses => [ '+18555072509' ],
            :emails => [ 'andrazedge@gmail.com' ],
            :subscribed_smses => [ '+18555072509' ],
            :subscribed_emails => [ 'andrazedge@gmail.com' ],
            :order_id => 'ID 1234',
            :order_id_path => 'http://www.aftership.com/order_id=1234',
            :custom_fields => {
                :product_name => 'iPhone Case',
                :product_price => 'EUR19.99'
            },
            :language => 'en',
            :order_promised_delivery_date => '2019-05-20',
            :delivery_type => 'pickup_at_store',
            :pickup_location => 'Bus station',
            :pickup_note => 'Good luck'
        }

        AfterShip::V4::Tracking.create(tracking_number, data)
    end

    def get_tracking(slug, tracking_number)
        AfterShip::V4::Tracking.get(slug, tracking_number)
    end

    def get_all_trackigns()
        AfterShip::V4::Tracking.get_all
    end

    def update_tracking(slug, tracking_number)
        data = {
            :title => 'Updated Title'
        }

        AfterShip::V4::Tracking.update(slug, tracking_number, data)
    end

    def retrack_tracking(slug, tracking_number)
        AfterShip::V4::Tracking.retrack(slug, tracking_number)
    end

    def delete_tracking(slug, tracking_number)
        AfterShip::V4::Tracking.delete(slug, tracking_number)
    end

    def get_last_checkpoint(slug, tracking_number)
        AfterShip::V4::LastCheckpoint.get(slug, tracking_number)
    end
end

def print_json(var, data)
    puts "\e[43m\e[30m #{var} \e[0m: \e[34m#{JSON.pretty_generate(data)}\e[0m"
end

tracking_number = (0...18).map { rand(2) == 0 ? rand(9) : (65 + rand(26)).chr }.join
slug = 'ups'

tracker = Tracker.new
print_json("create_tracking", tracker.create_tracking(slug, tracking_number))
print_json("update_tracking", tracker.update_tracking(slug, tracking_number))
print_json("get_tracking", tracker.get_tracking(slug, tracking_number))