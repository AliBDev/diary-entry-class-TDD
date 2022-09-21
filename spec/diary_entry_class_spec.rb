require_relative "../lib/diary_entry_class"

RSpec.describe DiaryEntry do
  it "constructs" do
    diary_entry = DiaryEntry.new("my_title", "my_contents")
    expect(diary_entry.title).to eq "my_title"
    expect(diary_entry.contents).to eq "my_contents"
  end

  describe "#count_words" do
    it "returns the number of words in the contents" do
      diary_entry = DiaryEntry.new("my_title", "contents go here")
      expect(diary_entry.count_words).to eq 3
    end

    it "returns zero when the contents are empty" do
      diary_entry = DiaryEntry.new("my_title", "")
      expect(diary_entry.count_words).to eq 0
    end
  end

  describe "#reading_time" do
    context "given a wpm of 200" do
      it "returns the ceiling number of minutes it takes to read the contents" do
        diary_entry = DiaryEntry.new("my_title", "one " * 550)
        expect(diary_entry.reading_time(200)).to eq 3
      end
    end

    context "given a wpm of 0" do
      it "fails" do
        diary_entry = DiaryEntry.new("my_title", "sample text")
        expect { diary_entry.reading_time(0) }.to raise_error "Reading speed must be above zero."
      end
    end
  end
end
