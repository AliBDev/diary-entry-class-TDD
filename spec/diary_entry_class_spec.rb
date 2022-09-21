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

  describe "#reading_chunk" do
    context "with a contents readable within the given minutes" do
      it "returns the full contents" do
        diary_entry = DiaryEntry.new("my_title", "sample text")
        chunk = diary_entry.reading_chunk(200, 1)
        expect(chunk).to eq "sample text"
      end
    end

    context "given a wpm of 0" do
      it "fails" do
        diary_entry = DiaryEntry.new("my_title", "sample text")
        expect { diary_entry.reading_chunk(0, 5) }.to raise_error "Reading speed must be above zero."
      end 
    end

    context "with a contents unreadable within the time" do
      it "returns a readable chunk" do
        diary_entry = DiaryEntry.new("my_title", "sample text here")
        chunk = diary_entry.reading_chunk(2, 1)
        expect(chunk).to eq "sample text"
      end

      it "returns the next chunk, next time we are asked" do
        diary_entry = DiaryEntry.new("my_title", "sample text here")
        diary_entry.reading_chunk(2, 1)
        chunk = diary_entry.reading_chunk(2, 1)
        expect(chunk).to eq "here"
      end

      it "restarts after reading the whole contents" do
        diary_entry = DiaryEntry.new("my_title", "sample text here")
        diary_entry.reading_chunk(2, 1)
        diary_entry.reading_chunk(2, 1)
        chunk = diary_entry.reading_chunk(2, 1)
        expect(chunk).to eq "sample text"
      end

      it "restarts if it finishes exactly on the end" do
        diary_entry = DiaryEntry.new("my_title", "sample text here")
        diary_entry.reading_chunk(2, 1)
        diary_entry.reading_chunk(1, 1)
        chunk = diary_entry.reading_chunk(2, 1)
        expect(chunk).to eq "sample text"
      end
    end
  end
end
