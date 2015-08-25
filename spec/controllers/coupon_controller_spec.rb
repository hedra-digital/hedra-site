require 'rails_helper'

describe CouponController do
  describe ".set_cookie" do
    context "with a valid slug" do
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

      it "create a new cookie" do
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
  end
end
