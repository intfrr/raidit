require 'unit/test_helper'
require 'interactors/list_signups'
require 'models/raid'
require 'models/character'

describe ListSignups do

  describe "#for_raid" do
    before do
      @raid = Raid.new
    end

    it "finds all signups for the given raid, grouped by acceptance state" do
      s1 = Signup.new raid: @raid, role: "healer"
      s1.acceptance_status = :accepted

      s2 = Signup.new raid: @raid, role: "healer"
      s2.acceptance_status = :available

      Repository.for(Signup).save(s1)
      Repository.for(Signup).save(s2)

      action = ListSignups.new
      signups = action.for_raid(@raid)

      signups.accepted("healer").must_equal [s1]
      signups.available("healer").must_equal [s2]
      signups.cancelled("healer").must_equal []
    end

    it "returns empty set if no signups found" do
      action = ListSignups.new
      signups = action.for_raid(@raid)

      signups.accepted("tank").must_equal []
      signups.available("healer").must_equal []
      signups.cancelled("dps").must_equal []
    end

  end

  describe ListSignups::Signups do
    it "knows if a given character is in a group" do
      c = Character.new
      s = ListSignups::Signups.new

      s.contains?(c).must_equal false

      s.add_signup Signup.new(character: c, role: "tank")

      s.contains?(c).must_equal true
    end
  end
end
