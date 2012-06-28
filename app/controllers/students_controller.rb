class StudentsController < ApplicationController
  # GET /students
  # GET /students.json

  # Page Caching
  caches_page :index
  caches_page :image, :gzip => :best_speed

  def index
    @students = Student.all

    #Set the # of pictures to return from the Flickr API (index) and the tag 
    @urll2 = Array.new(5)
    @index = 4
    (1..@index).each do |p|
    	flickrAPI(p, "Bethel church")

	set_urll2(p)
    end

    @urll3 = Array.new(5)
    (1..@index).each do |q|
	    flickrAPI(q, "Bethel")

	    set_urll3(q)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @students }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])

    #If the request is stale according to the given timestamp and etag value then execute the code
    if stale?(:last_modified => @student.updated_at.utc, :etag => @student)
    	respond_to do |format|
      	    format.html # show.html.erb
      	    format.json { render json: @student }
    	end
    end
  end

  # GET /students/new
  # GET /students/new.json
  def new
    @student = Student.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render json: @student, status: :created, location: @student }
      else
        format.html { render action: "new" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end

  def flickrAPI(num_pages, tag_value)
	require 'net/http'
	require 'uri'
	require 'rexml/document'
	uri = URI.parse("http://api.flickr.com/services/rest/")

	params={'method'=>'flickr.photos.search','api.key'=>'cf605e9203bdddb1fd806b04a620ce50','accuracy'=>'10','sort'=>'relevance','media'=>'photos','tags'=>tag_value,'page'=>num_pages}

	http=Net::HTTP.new(uri.host,uri.port)
	request=Net::HTTP::Get.new(uri.path)
	request.set_form_data(params)

	#instantiate a new Request object
	request=Net::HTTP::Get.new(uri.path+'?'+request.body)

	response = http.request(request)
	xml_data = response.body

	doc = REXML::Document.new(xml_data)
		doc.root.elements[1].each_element{|e|
		if e.attributes['title'] =~ /#{Regexp.escape(tag_value)}/i
		@urll="http://farm"+e.attributes['farm']+".static.flickr.com/"+e.attributes['server']+"/"+e.attributes['id']+"_"+e.attributes['secret']+".jpg";
#		@flickrURL.push(url)
		end
		}
   end

  def set_urll2(idx)
	@urll2[idx] = @urll
  end

  def set_urll3(idx)
	@urll3[idx] = @urll
  end

end	  
