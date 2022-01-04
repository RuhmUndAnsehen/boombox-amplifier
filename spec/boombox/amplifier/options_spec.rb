# frozen_string_literal: true

require 'boombox/amplifier/options'

PRECISION = 1e-6

RSpec.describe Boombox::LeisenReimerEngine do
  describe '.params' do
    it 'should return the expected parameter names' do
      expect(described_class.params.keys.sort).to eq(%i[expiry iv price rate
                                                        steps strike style type
                                                        underlying])
    end
  end
  describe '#solve' do
    engine = described_class.new
    context 'with underlying price at 100' do
      engine.underlying!(Boombox::Underlying.new(100, Time.new(2000, 1, 1)))
      context 'and rate at 0.07' do
        engine.rate!(0.07)
        context 'and implied volatility at 0.3' do
          engine.iv!(0.3)
          context 'and tte 0.5 years' do
            engine.expiry!(Time.new(2000, 1, 1) + 365 * 12 * 3600)
            context 'and 25 steps' do
              engine.steps!(25)
              it 'should compute European style call prices' do
                engine2 = engine.style(:european).type(:call)
                expect(engine2.strike(80).solve.price.round(5))
                  .to be_within(PRECISION).of(23.75822)
                expect(engine2.strike(90).solve.price.round(5))
                  .to be_within(PRECISION).of(16.09941)
                expect(engine2.strike(100).solve.price.round(5))
                  .to be_within(PRECISION).of(10.13316)
                expect(engine2.strike(110).solve.price.round(5))
                  .to be_within(PRECISION).of(5.94889)
                expect(engine2.strike(120).solve.price.round(5))
                  .to be_within(PRECISION).of(3.28258)
              end
              it 'should compute European style put prices' do
                engine2 = engine.style(:european).type(:put)
                expect(engine2.strike(80).solve.price.round(5))
                  .to be_within(PRECISION).of(1.00665)
                expect(engine2.strike(90).solve.price.round(5))
                  .to be_within(PRECISION).of(3.00390)
                expect(engine2.strike(100).solve.price.round(5))
                  .to be_within(PRECISION).of(6.69370)
                expect(engine2.strike(110).solve.price.round(5))
                  .to be_within(PRECISION).of(12.16548)
                expect(engine2.strike(120).solve.price.round(5))
                  .to be_within(PRECISION).of(19.15523)
              end
              it 'should compute American style put prices' do
                engine2 = engine.style(:american).type(:put)
                expect(engine2.strike(80).solve.price.round(5))
                  .to be_within(PRECISION).of(1.04264)
                expect(engine2.strike(90).solve.price.round(5))
                  .to be_within(PRECISION).of(3.12832)
                expect(engine2.strike(100).solve.price.round(5))
                  .to be_within(PRECISION).of(7.02858)
                expect(engine2.strike(110).solve.price.round(5))
                  .to be_within(PRECISION).of(12.93136)
                expect(engine2.strike(120).solve.price.round(5))
                  .to be_within(PRECISION).of(20.67576)
              end
            end
          end
        end
      end
    end
  end
end