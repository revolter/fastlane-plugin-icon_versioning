describe Fastlane::Actions::IconVersioningAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The icon_versioning plugin is working!")

      Fastlane::Actions::IconVersioningAction.run(nil)
    end
  end
end
