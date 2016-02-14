class QuotesController < Rulers::Controller
  def a_quote
    render :a_quote, :noun => :winking
  end

  def quote_1
    quote_1 = FileModel.find(1)
    render :quote, :obj => quote_1
  end

  def index
    req = Rack::Request.new(@env)
    if req.params['submitter'].nil?
      quotes = FileModel.all
    else
      quotes = FileModel.find_all_by_submitter(req.params['submitter'])
    end
    render :index, :quotes => quotes
  end

  def new_quote
    attrs = {
      "submitter" => "web user",
      "quote" => "A picture is worth one k pixels",
      "attribution" => "Me"
    }
    m = FileModel.create attrs
    render :quote, :obj => m
  end

  def update_quote
    req = Rack::Request.new(@env)

    quote_1 = FileModel.find(1)
    quote_1['submitter'] = req.params['submitter']
    quote_1.save

    render :quote, obj: quote_1
  end
end
