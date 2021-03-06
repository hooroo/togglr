require 'togglr/base_toggle'
require 'togglr/base_repository'

module Togglr
  describe BaseToggle do

    let(:repositories) { [] }
    let(:toggle_name) { :test_toggle }
    let(:toggle_value) { true }
    let(:toggle) { BaseToggle.new(toggle_name, toggle_value, repositories) }


    describe '#active?' do
      context 'without any repositories' do
        it 'returns the default value' do
          expect(toggle.active?).to eq toggle_value
        end
      end

      context 'with multiple repositories' do
        let(:repositories) { [test_repo1, test_repo2] }
        let(:test_repo_class_1) do
          Class.new(BaseRepository) do
            attr_accessor :toggles

            def initialize
              @toggles = {}
            end

            def read(name)
              @toggles[name]
            end

            def write(name, value)
              @toggles[name] = value
            end
          end
        end
        let(:test_repo1) { test_repo_class_1.new }

        let(:test_repo_class_2) { Class.new(test_repo_class_1) }
        let(:test_repo2) { test_repo_class_2.new }

        context 'with toggle state set in top-level repository' do
          let(:toggle_value) { false }
          it 'fetches the value from the top-level repository' do
            test_repo1.toggles[toggle_name] = toggle_value
            test_repo2.toggles[toggle_name] = !toggle_value

            expect(toggle.active?).to eq toggle_value
          end

          it 'ignores any values from deeper repositories' do
            test_repo1.toggles[toggle_name] = toggle_value
            test_repo2.toggles[toggle_name] = !toggle_value
            expect(test_repo2).to_not receive(:read_or_delegate)

            expect(toggle.active?).to eq toggle_value
          end
        end

        context 'with toggle state not in top-level repository' do
          let(:repo2_toggle_value) { !toggle_value }
          it 'delegates to a lower-level repository' do
            test_repo1.toggles.delete(toggle_name)
            test_repo2.toggles[toggle_name] = repo2_toggle_value

            expect(toggle.active?).to eq repo2_toggle_value
          end
        end

        context 'with no toggle states in any repository' do
          # let(:toggle_value) { false }
          it 'returns the default value' do
            test_repo1.toggles.delete(toggle_name)
            test_repo2.toggles.delete(toggle_name)

            expect(toggle.active?).to eq toggle_value
          end
        end
      end

    end

    describe '#description' do
      let(:toggle_value) { { value: true, description: description } }
      context 'when supplied a description' do
        let(:description) {  'This is the description' }
        it 'returns the given description' do
          expect(toggle.description).to eq description
        end
      end

      context 'when not supplied a description' do
        let(:description) { nil }
        it 'returns a default description' do
          expect(toggle.description).to_not eq description
        end
      end
    end

  end
end
