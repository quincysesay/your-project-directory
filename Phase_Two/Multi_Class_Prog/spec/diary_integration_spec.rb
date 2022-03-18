require 'diary'
require 'diary_entry'

RSpec.describe 'dairy_integration' do

    it "returns the entries added" do
      diary = Diary.new
      diary_entry_1 = DiaryEntry.new("my title", "my content")
      diary_entry_2 = DiaryEntry.new("my title 2", "my content 2")
      diary.add(diary_entry_1)
      diary.add(diary_entry_2)
      expect(diary.all).to eq [diary_entry_1, diary_entry_2]
    end
  
    describe "counting the words in content" do
      it "counts the words in all diary entry content" do
        diary = Diary.new
        diary_entry_1= DiaryEntry.new("my title", "my content")
        diary_entry_2 = DiaryEntry.new("my title 1", "my content 1")
        diary.add(diary_entry_1)
        diary.add(diary_entry_2)
        expect(diary.count_words).to eq 5
      end
    end

    describe "getting the reading time" do
      it "fails where wpm is 0" do
        diary = Diary.new
        diary_entry_1= DiaryEntry.new("my title", "my content 2")
        diary.add(diary_entry_1)
        expect {diary.reading_time(0)}.to raise_error "WPM cannot be 0."
      end 

      it "calculates the reading time for all entries where it fits eaxclty" do
        diary = Diary.new
        diary_entry_1= DiaryEntry.new("my title", "my content 2")
        diary_entry_2 = DiaryEntry.new("my title 1", "my content 1")
        diary.add(diary_entry_1)
        diary.add(diary_entry_2)
        expect(diary.reading_time(2)).to eq 3
      end

      it "calculates the reading time for all entries where it falls over a minute" do
        diary = Diary.new
        diary_entry_1= DiaryEntry.new("my title", "my content")
        diary_entry_2 = DiaryEntry.new("my title 1", "my content 1")
        diary.add(diary_entry_1)
        diary.add(diary_entry_2)
        expect(diary.reading_time(2)).to eq 3
      end
    end

    describe "best reading time entry behaviour" do
      it "fails where wpm is 0" do
        diary = Diary.new
        diary_entry_1= DiaryEntry.new("my title", "my content")
        diary.add(diary_entry_1)
        expect { diary.find_best_entry_for_reading_time(0, 1)}.to raise_error("WPM cannot be 0.")
      end


      context "where we just have one entry and it is readable in the time" do
        it "returns that entry" do
          diary = Diary.new
          diary_entry_1= DiaryEntry.new("my title", "my content")
          diary.add(diary_entry_1)
          result = diary.find_best_entry_for_reading_time(2, 1)
          expect(result).to eq diary_entry_1
        end
      end

      context "where we just one entry and it is unreadable in the time" do
        it "return nil" do
          diary = Diary.new
          diary_entry_1= DiaryEntry.new("my title", "my content is a bit long")
          diary.add(diary_entry_1)
          result = diary.find_best_entry_for_reading_time(2, 1)
          expect(result).to eq nil
        end
      end

      context "where we have multiple entries" do
        it "returns the longest entry the user could read in this time" do
          diary = Diary.new
          best_entry = DiaryEntry.new("my title", "one two")
          diary.add(DiaryEntry.new("my title", "one"))
          diary.add(best_entry)
          diary.add(DiaryEntry.new("my title", "one two three"))
          diary.add(DiaryEntry.new("my title", "one two three four"))
          result = diary.find_best_entry_for_reading_time(2, 1)
          expect(result).to eq best_entry
        end
      end
    end
end