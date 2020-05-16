# -*- coding: utf-8 -*-

from openerp import fields, models, api


class MrpProduction(models.Model):
    _inherit = 'mrp.production'

    old_name = fields.Char(
        copy=False
    )

    name= fields.Char(
        states={},
        readonly=False,
        copy=False
    )

    @api.onchange('project_id')
    def modify_name_obchange(self):
        #print self.old_name
        if self.name !='/':
            if self.old_name == False or self.old_name == '':
                #print self.old_name
                self.update({'old_name' :self.name})
            if self.project_id and self.project_id.project_sequence:
                #self.name = self.old_name+self.project_id.project_sequence
                self.update({'name' :self.old_name+self.project_id.project_sequence})
                self.write({'name' :self.old_name+self.project_id.project_sequence})
            #print self.old_name

    @api.model
    def create(self, values):
        # Override the original create function for the res.partner model
        record = super(MrpProduction, self).create(values)
        if record.old_name == False or record.old_name == '':
            #print self.old_name
            record.write({'old_name' :record.name})
        if record.project_id and record.project_id.project_sequence:
            #self.name = self.old_name+self.project_id.project_sequence
            record.write({'name' :record.old_name+record.project_id.project_sequence})
        return record

    