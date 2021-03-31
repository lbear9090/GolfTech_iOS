#!/usr/bin/bacon
CONFIGURATION = ENV['CONFIGURATION'] || 'Debug'
BUILD_DIR = ENV['BUILD_DIR'] || 'build'

require 'bacon'
framework 'Cocoa'
puts `pwd`
framework "/Nobackup/Checkedout/Golf/App/build/Debug/Tests.framework"

describe 'A new repository' do
  before do
    @dep = DependencyInjector.new
    @rep = Repository.new
    @rep.dependencyInjector = @dep
  end
  
  it 'should have the right content' do
    categories = @rep.findCategories
    categories.length.should == 4
    categories[0].title.should == 'Putt'
    categories[0].code.should == 'pu'
    categories[0].evaluation.name.should == 'Utvärdering'
    categories[0].evaluation.identity.should == 'puutv'
    categories[0].exercises.length.should == 2
    categories[0].exercises[1].identity.should == 'puovn2'
    categories[0].exercises[0].identity.should == 'puovn1'
    categories[0].techniquesForLevel(1).length.should == 3
    categories[0].techniquesForLevel(1)[0].identity.should == 'pun1t1'
    categories[0].techniquesForLevel(1)[1].identity.should == 'pun1t2'
    categories[0].techniquesForLevel(1)[2].identity.should == 'pun1t3'
    categories[0].techniquesForLevel(2)[0].identity.should == 'pun2t1'
    categories[1].title.should == 'Chip'
    categories[1].evaluation.identity.should == 'cutv'
    categories[2].title.should == 'Bunker'
    categories[3].title.should == 'Pitch'
  end
  
end