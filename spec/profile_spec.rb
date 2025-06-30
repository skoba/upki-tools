RSpec.describe Profile do
  describe 'profile should be read from config/profile.yml' do
    subject { Profile }

    its(:c)  { is_expected.to eq 'JP' }
    its(:st) { is_expected.to eq 'Tokyo' }
    its(:l)  { is_expected.to eq 'Tokyo' }
    its(:o)  { is_expected.to eq '医療オープンソースソフトウェア協議会' }
    its(:name)  { is_expected.to eq 'KOBAYASHI Shinji' }
    its(:email) { is_expected.to eq 'skoba@moss.gr.jp' }
  end
end
