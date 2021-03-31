#!/usr/bin/bacon
CONFIGURATION = ENV['CONFIGURATION'] || 'Debug'
BUILD_DIR = ENV['BUILD_DIR'] || 'build'

require 'bacon'
framework 'Cocoa'
puts `pwd`
framework "/Nobackup/Checkedout/Golf/App/build/Debug/Tests.framework"

def view(width,height)
	result = UIView.new
	result.frame = NSMakeRect(0,0,width,height)
	return result
end

describe 'A fake view' do
	it 'has a view' do
		v = view(10,11)
		v.frame.should == CGRectMake(0, 0, 10, 11);
	end
end

describe 'A new ViewBuilder with no start frame' do
	
	before do
		@builder = ViewBuilder.verticalBuilder
	end
	
	it 'is properly created' do
		@builder.class.to_s.should == "ViewBuilder"
	end
	
	it 'can be built' do
		@builder.result.class.should == ViewBuilderResult
		@builder.result.extent.should == 0
		@builder.result.ortogonal.should == 0
	end
	
end

describe 'A empty ViewBuilder that has been built' do
	
	before do
		@result = ViewBuilder.verticalBuilder.build
	end
	
	it 'has a zero size parentframe' do
		@result.extent.should == 0
		@result.ortogonal.should == 0
	end
	
    it 'has no resulting frames' do
      @result.boxCount.should == 0
    end
    
end

describe 'A built ViewBuilder with vertically added items' do
	before do
		@view1 = view(10,20)
		@view2 = view(30,40)
		@builder = ViewBuilder.verticalBuilder
		@builder.addLeftView(@view1)
		@builder.addCenteredView(@view2)
		@builder.addSpace(15)
		@builder.ortogonal = 100
		@result = @builder.build 
	end
		
	it 'have layed out correctly' do
		@result.boxCount.should == 3
		@result.frameAtIndex(0).should == CGRectMake(0,0,10,20)
		@result.frameAtIndex(1).should  == CGRectMake(35,20,30,40)
		@result.frameAtIndex(2).should  == CGRectMake(0,60,0,15)
		@result.extent.should == 75
		@result.ortogonal.should == 30
	end
	
	it 'has updated the participating views' do
		@view1.frame.should == CGRectMake(0,0,10,20)
		@view2.frame.should == CGRectMake(35,20,30,40)
	end
end

describe 'A built ViewBuilder with horizontally added items' do
	before do
		@view1 = view(20,10)
		@view2 = view(40,30)
		@builder = ViewBuilder.horizontalBuilder
		@builder.addLeftView(@view1)
		@builder.addLeftView(@view2)
		@builder.addSpace(15)
		@result = @builder.build 
	end
		
	it 'have layed out correctly' do
		@result.boxCount.should == 3
		@result.frameAtIndex(0).should == CGRectMake(0,0,20,10)
		@result.frameAtIndex(1).should  == CGRectMake(20,0,40,30)
		@result.frameAtIndex(2).should  == CGRectMake(60,0,15,0)
		@result.extent.should == 75
		@result.ortogonal.should == 30
	end
	
	it 'has updated the participating views' do
		@view1.frame.should == CGRectMake(0,0,20,10)
		@view2.frame.should == CGRectMake(20,0,40,30)
	end
end

describe 'A built ViewBuilder with flexible space' do
	before do
		@view1 = view(20,10)
		@view2 = view(40,30)
		@builder = ViewBuilder.verticalBuilder
		@builder.addLeftView(@view1)
		@builder.addFlexibleSpaceWithFactor(1)
		@builder.addLeftView(@view2)
		@builder.addFlexibleSpaceWithFactor(2)
		@builder.extent = 85
		@result = @builder.build 
	end
		
	it 'have layed out correctly' do
		@result.boxCount.should == 4
		@result.frameAtIndex(0).should == CGRectMake(0,0,20,10)
		@result.frameAtIndex(1).should == CGRectMake(0,10,0,15) #
		@result.frameAtIndex(2).should == CGRectMake(0,25,40,30)
		@result.frameAtIndex(3).should == CGRectMake(0,55,0,30)
	end
	
	it 'has updated the participating views' do
		@view1.frame.should == CGRectMake(0,0,20,10)
		@view2.frame.should == CGRectMake(0,25,40,30)
	end
end

describe 'A built ViewBuilder with flexible space and centered items' do
	before do
		@view1 = view(90,30)
		@view2 = view(90,30)
		@view3 = view(90,30)
		@builder = ViewBuilder.horizontalBuilder
		@builder.addSpace(10)
		@builder.addLeftView(@view1)
		@builder.addFlexibleSpaceWithFactor(1)
		@builder.addCenteredView(@view2)
		@builder.addFlexibleSpaceWithFactor(1)
		@builder.addLeftView(@view3)
		@builder.addSpace(10)
		@builder.extent = 320
		@builder.ortogonal = 100
		@result = @builder.build 
	end
		
	it 'has updated the participating views' do
		@view1.frame.should == CGRectMake(10, 0, 90,30)
		@view2.frame.should == CGRectMake(115,35,90,30)
		@view3.frame.should == CGRectMake(220,0,90,30)
	end
end

