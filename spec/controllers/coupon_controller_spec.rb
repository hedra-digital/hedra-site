require 'rails_helper'

describe CouponController do
  describe ".set_cookie" do
    context "with a valid slug" do
      context "when is a normal promotion" do
        let(:slug) { "fAkE1-a222-ReAlLy-bIg3-SlUg-5555" }
        let(:ended_at) { DateTime.parse("2014-12-31 19:00:00") }
        let(:link) { nil }

        let(:promotion) do
          p = Promotion.new(slug: slug, ended_at: ended_at, link: link)

          allow(p).to receive(:id).and_return(1007)
          p
        end

        before(:each) do
          allow(Promotion).to receive(:find_by_slug).with(slug).and_return(promotion)
        end

        it "sets a new cookie" do
          get :set_cookie, id: slug

          expect(@response.cookies["coupon_1007"]).to eq(slug)
        end

        it "sets the cookie experiation" do
          stub_cookie_jar = HashWithIndifferentAccess.new
          allow(controller).to receive(:cookies) { stub_cookie_jar }

          get :set_cookie, id: slug

          cookie = stub_cookie_jar["coupon_1007"]
          expect(cookie[:expires]).to eq(ended_at)
        end

        context "with a not blank link" do
          let(:link) { "http://fake.url" }
          before(:each) { get :set_cookie, id: slug }

          it { is_expected.to redirect_to link }
        end

        context "with a blank link" do
          before(:each) { get :set_cookie, id: slug }

          it { is_expected.to redirect_to :root }
        end
      end

      context "when is a campaing" do
        let(:slug) { "fAkE1-a222-ReAlLy-bIg3-SlUg-6006" }
        let(:link) { nil }

        let(:promotion) do
          p = Promotion.new(slug: slug, started_at: started_at, ended_at: ended_at, name: "Some Campaign Name", for_traffic_origin: true )

          allow(p).to receive(:id).and_return(8008)
          p
        end

        before(:each) do
          allow(Promotion).to receive(:find_by_slug).with(slug).and_return(promotion)
        end

        context "when is valid" do
          let(:ended_at) { Date.tomorrow }
          let(:started_at) { Date.yesterday }
          let(:link) { nil }

          it "sets a new cookie" do
            get :set_cookie, id: slug

            expect(@response.cookies["current_campaign"]).to eq("8008_some_campaign_name")
          end

          it "sets the cookie experiation" do
            stub_cookie_jar = HashWithIndifferentAccess.new
            allow(controller).to receive(:cookies) { stub_cookie_jar }

            get :set_cookie, id: slug

            cookie = stub_cookie_jar["current_campaign"]
            expect(cookie[:expires].to_i).to be_within(100).of(1.hour.from_now.to_i)
          end
        end

        context "when is invalid" do
          let(:started_at) { 2.days.ago }
          let(:ended_at) { Date.yesterday }

          it "doesn't set a cookie" do
            get :set_cookie, id: slug

            expect(@response.cookies["current_campaign"]).to be_nil
          end
        end
      end
    end
  end
end
