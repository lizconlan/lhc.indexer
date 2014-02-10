class Mappings
  def self.index_names
    ["commons_hansard"]
  end
  
  def self.all_mappings
    {
      commons_hansard:
        {contents: {
          debate: {
            properties: {
              title: { type: "string", index: "analyzed" },
              text:  { type: "string", index: "analyzed" },
              date:  { type: "date", index: "analyzed" },
              hansard_component: { type: "string", index: "analyzed" },
              hansard_ref: { type: "string", index: "analyzed" },
              bill_title: { type: "string", index: "analyzed"},
              extended_bill_title: { type: "string", index: "analyzed"},
              members: { type: "string", index: "not_analyzed" },
              chair: { type: "string", index: "analyzed" },
              url: { type: "string", index: "not_analyzed" }
            }
          },
          question: {
            properties: {
              title: { type: "string", index: "analyzed" },
              text:  { type: "string", index: "analyzed" },
              date:  { type: "date", index: "analyzed" },
              hansard_component: { type: "string", index: "analyzed" },
              hansard_ref: { type: "string", index: "analyzed" },
              question_type: { type: "string", index: "analyzed" },
              number: { type: "string", index: "analyzed" },
              asked_by: { type: "string", index: "analyzed" },
              subject: { type: "string", index: "analyzed" },
              department: { type: "string", index: "analyzed" },
              members: { type: "string", index: "not_analyzed" },
              url: { type: "string", index: "not_analyzed" }
            }
          },
          statement: {
            properties: {
              title: { type: "string", index: "analyzed" },
              text:  { type: "string", index: "analyzed" },
              date:  { type: "date", index: "analyzed" },
              hansard_component: { type: "string", index: "analyzed" },
              hansard_ref: { type: "string", index: "analyzed" },
              columns: { type: "string", index: "analyzed" },
              subject: { type: "string", index: "analyzed" },
              department: { type: "string", index: "analyzed" },
              members: { type: "string", index: "not_analyzed" },
              url: { type: "string", index: "not_analyzed" }
            }
          }
        }
      }
    }
  end
end