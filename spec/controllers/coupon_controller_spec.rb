require 'rails_helper'

describe CouponController do
  describe ".set_cookie" do
    context "with a valid slug" do
      let(:slug) { "fAkE1-a222-ReAlLy-bIg3-SlUg-5555" }
      let(:ended_at) { DateTime.parse("2014-12-31 19:00:00") }
      let(:promotion) do
        p = Promotion.new(slug: slug, ended_at: ended_at)

        allow(p).to receive(:id).and_return(1007)
        p
      end

      before do
        allow(Promotion).to receive(:find_by_slug).with(slug).and_return(promotion)
      end

      it "assigns a new cookie" do
        get :set_cookie, id: slug

        expect(@response.cookies["coupon_1007"]).not_to be_nil
      end
    end
  end
end
